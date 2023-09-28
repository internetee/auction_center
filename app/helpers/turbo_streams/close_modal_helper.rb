module TurboStreams::CloseModalHelper
  def close_modal(modal_class, open_class, form_id)
    turbo_stream_action_tag :close_modal, modal_class: modal_class, open_class: open_class, form_class: form_id
  end
end

Turbo::Streams::TagBuilder.prepend(TurboStreams::CloseModalHelper)
