defmodule Surface.Example do
  @moduledoc """
  A generic live view to create examples for catalogues.
  """

  @default_head """
  <link phx-track-static rel="stylesheet" href="/css/app.css"/>
  """

  defmacro __using__(opts) do
    subject = Keyword.fetch!(opts, :subject)

    quote do
      use Surface.LiveView

      alias unquote(subject)
      require Surface.Catalogue.Data, as: Data

      @opts unquote(opts)
      @before_compile unquote(__MODULE__)

      import Surface, except: [sigil_H: 2]

      defmacrop sigil_H({:<<>>, meta, [string]} = ast, opts) do
        Module.put_attribute(__CALLER__.module, :code, string)
        quote do
          Surface.sigil_H(unquote(ast), unquote(opts))
        end
      end
    end
  end

  defmacro __before_compile__(env) do
    opts = Module.get_attribute(env.module, :opts)
    code = Module.get_attribute(env.module, :code)

    head = Keyword.get(opts, :head, @default_head)
    style = Keyword.get(opts, :style)
    class = Keyword.get(opts, :class)
    title = Keyword.get(opts, :title)
    direction = Keyword.get(opts, :direction)
    code_perc = Keyword.get(opts, :code_perc)
    subject = Keyword.get(opts, :subject)

    quote do
      @moduledoc catalogue: [
        subject: unquote(subject),
        head: unquote(head),
        style: unquote(style),
        class: unquote(class),
        title: unquote(title),
        code: unquote(code),
        direction: unquote(direction),
        code_perc: unquote(code_perc)
      ]
    end
  end
end