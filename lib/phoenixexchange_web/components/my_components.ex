defmodule PhoenixexchangeWeb.MyComponents do
  use Phoenix.Component
  use Gettext, backend: PhoenixexchangeWeb.Gettext
  import PhoenixexchangeWeb.Icons

  attr :icon, :string, default: nil
  attr :class, :string, default: nil
  attr :tip, :string, default: nil
  attr :icon_class, :string, default: nil
  attr :cont, :string, default: nil

  def icon_button(assigns) do
    ~H"""
    <span class={@class} data-tip={@tip}>
      <.icon name={@icon} class={@icon_class} />
      {@cont}
    </span>
    """
  end

  def lightweight_chart(assigns) do
    ~H"""

    """
  end
end
