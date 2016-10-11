defmodule Eatery.CashierTest do
  use ExUnit.Case
  doctest Eatery.Cashier

  import  Eatery.Cashier

#  test "the truth" do
#    assert 1 + 1 == 2
#  end
#
#  test "capitalization" do
#    assert capitalize_words("some very long" ) == "Some Very Long"
#  end

  test "get-money" do
    cashier_pid = create_unit()

    send(cashier_pid, {:money, 10, self()})
      receive do
        {:require_more, msg} -> assert msg == "Not enough money 990"
    end
  end

  test "executor" do
    assert execute(3, fn (value) -> value + 1 end, 20, 1) == 21
  end

end
