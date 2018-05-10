defmodule ElixirDbf.Header do
  @moduledoc """
    ElixirDbf.Header module
  """

  @header_size 32

  def parse(file) do
    raw_header = IO.read(file, @header_size)
    <<
      version::size(8),
      date::size(24),
      records::little-integer-size(32),
      header_size::little-integer-size(16),
      record_size::little-integer-size(16),
      _reserved_zeros_1::size(16),
      incomplete_transaction::size(8),
      encryption_flag::size(8),
      _multi_user_processing::size(96),
      mdx_flag::size(8),
      language_driver_id::size(8),
      _reserved_zeros_2::size(16)
    >> = raw_header

    %{
      version: version,
      date: date,
      records: records,
      header_size: header_size,
      record_size: record_size,
      incomplete_transaction: incomplete_transaction,
      encryption_flag: encryption_flag,
      mdx_flag: mdx_flag,
      language_driver_id: language_driver_id,
      columns: parse_columns(file)
    }
  end

  def parse_columns(file, columns \\ []) do
    case IO.read(file, 1) do
      "\r" ->
        Enum.reverse(columns)

      start_byte ->
        field_block = start_byte <> IO.read(file, @header_size - 1)

        <<
          name::binary-size(11),
          type::binary-size(1),
          _displacement::binary-size(4),
          field_size::integer-size(8),
          _decimal_places::binary-size(1),
          _field_flag::binary-size(1),
          _next::binary-size(4),
          _step::binary-size(1),
          _reserved::binary-size(8)
        >> = field_block

        column = %{
          name: String.trim_trailing(name, <<0>>),
          type: detect_type(type),
          # displacement: displacement,
          field_size: field_size,
          # decimal_places: decimal_places,
          # field_flag: field_flag,
          # next: next,
          # step: step
        }

        parse_columns(file, [column | columns])
    end
  end

  def detect_type(char) do
    case char do
      "C" -> :string # Character
      "Y" -> :currency # Currency
      "N" -> :numeric # Numeric
      "F" -> :float # Float
      "D" -> :date # Date
      "T" -> :datetime # DateTime
      "B" -> :float # Double
      "I" -> :integer # Integer
      "L" -> :boolean # Logical
      "M" -> :memo # Memo
      "G" -> :general # General
      "P" -> :picture # Picture
      "+" -> :autoincrement # Autoincrement (dBase Level 7)
      "O" -> :float # Double (dBase Level 7)
      "@" -> :datetime # Timestamp (dBase Level 7)
      "V" -> :string # Varchar type (Visual Foxpro)
    end
  end
end
