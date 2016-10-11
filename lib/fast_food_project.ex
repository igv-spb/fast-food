defmodule Eatery.Cashier do

    def listen_msg do
      receive do
        {:money, amount, client_pid} -> send(client_pid, { :require_more, "Not enough money #{1000 - amount}" } )
      end
    end

    def process_msg(func, next_pid) do
        receive do
          {:execute, tl, value} ->
                if tl != 0 do
                    send(next_pid, {:execute, tl - 1, func.(value)})
                    process_msg(func, next_pid)
                else
                    send(next_pid, {:execute, 0, value})
                end
        end
    end

    defp parent_process_msg(func, next_pid) do
        receive do
           {:execute, tl, value} ->
                if tl != 0 do
                    send(next_pid, {:execute, tl - 1, func.(value)})
                    parent_process_msg(func, next_pid)
                else
                    value
                end
        end
    end

    defp create_actor(next_pid, func, i) when i <= 1 do next_pid end
    defp create_actor(next_pid, func, i) do
      new_pid = spawn(Eatery.Cashier, :process_msg, [func, next_pid])
      create_actor(new_pid, func, i - 1)
    end

    def execute(actors_count, func, tl, initial_value) do
      next_pid = create_actor(self(), func, actors_count)
      send(next_pid, {:execute, tl - 1, func.(initial_value)})
      parent_process_msg(func, next_pid)
    end

    def create_unit do
        spawn( Eatery.Cashier, :listen_msg, [])
    end

    def capitalize_words(str) do
        Enum.map_join(String.split(str, " "), " ", fn item -> String.capitalize item end )
    end
end
