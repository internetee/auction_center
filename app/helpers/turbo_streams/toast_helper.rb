module TurboStreams::ToastHelper
  def toast(message, position: "left")
    turbo_stream_action_tag :toast, message: message, position: position
  end
end

Turbo::Streams::TagBuilder.prepend(TurboStreams::ToastHelper)
