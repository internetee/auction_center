module TurboStreams::ToastHelper
  def toast(message, position: "left", **options)
    turbo_stream_action_tag :toast, message: message, position: position, **options
  end
end

Turbo::Streams::TagBuilder.prepend(TurboStreams::ToastHelper)
