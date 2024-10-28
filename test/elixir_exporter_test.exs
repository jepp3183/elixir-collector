defmodule ElixirExporterTest do
  use ExUnit.Case
  doctest ElixirExporter

  test "greets the world" do
    assert ElixirExporter.hello() == :world
  end
end
