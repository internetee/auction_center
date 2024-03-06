require "test_helper"

class ButtonToTest < ViewComponent::TestCase
  # puts rendered_content
  def test_render_delete_component
    @user = users(:participant)
    @auction = auctions(:valid_with_offers)

    render_inline(Common::Buttons::ButtonTo::Component.new(
      title_caption: 'Delete', color: 'ghost',
      href: route.offer_path(@auction.offer_from_user(@user).uuid),
      options: { method: :delete, form_attributes:  { data: { turbo_confirm: confirmation_iternalization } } })
    )

    assert_selector "form.button_to[method='post'][action='#{route.offer_path(@auction.offer_from_user(@user).uuid)}']"
    assert_selector "form.button_to input[type='hidden'][name='_method'][value='delete']", visible: false
    assert_selector "form.button_to button.c-login__button.c-btn.c-btn--ghost[type='submit']", text: 'Delete'    
  end

  def test_render_nested_delete_component
    @user = users(:participant)
    @auction = auctions(:valid_with_offers)

    render_inline(Common::Buttons::ButtonTo::Component.new(
      title_caption: nil, color: 'ghost',
      href: route.offer_path(@auction.offer_from_user(@user).uuid),
      options: { method: :delete, form_attributes:  { data: { turbo_confirm: confirmation_iternalization } } })
    ) do
      'Delete'
    end

   assert_selector "form.button_to[method='post'][action='#{route.offer_path(@auction.offer_from_user(@user).uuid)}']"
   assert_selector "form.button_to input[type='hidden'][name='_method'][value='delete']", visible: false
   assert_selector "form.button_to button.c-btn--icon.c-btn.c-btn--ghost[type='submit']", text: 'Delete'
  end

  def test_render_post_component
    @user = users(:participant)
    @auction = auctions(:valid_with_offers)

    render_inline(Common::Buttons::ButtonTo::Component.new(
      title_caption: 'Create',
      href: route.offer_path(@auction.offer_from_user(@user).uuid),
      color: 'ghost', options: { method: :post })
    )

    assert_selector "form.button_to[method='post'][action='#{route.offer_path(@auction.offer_from_user(@user).uuid)}']"
    assert_selector "form.button_to button.c-login__button.c-btn.c-btn--ghost[type='submit']", text: 'Create'
  end

  def test_inline_button_colorize
    @user = users(:participant)
    @auction = auctions(:valid_with_offers)

    render_inline(Common::Buttons::ButtonTo::Component.new(
      title_caption: 'Delete',
      href: route.offer_path(@auction.offer_from_user(@user).uuid),
      color: 'ghost', options: { 
        method: :delete, form_attributes:  { data: { turbo_confirm: confirmation_iternalization } }})
    )
    
    assert_selector "form.button_to button.c-login__button.c-btn.c-btn--ghost[type='submit']", text: 'Delete'
    assert_selector "form.button_to[action='#{route.offer_path(@auction.offer_from_user(@user).uuid)}']"

    render_inline(Common::Buttons::ButtonTo::Component.new(
      title_caption: 'Delete', color: 'blue-secondary',
      href: route.offer_path(@auction.offer_from_user(@user).uuid),
      options: { method: :delete, form_attributes:  { data: { turbo_confirm: confirmation_iternalization } }})
    )
    assert_selector "form.button_to button.c-login__button.c-btn.c-btn--blue-secondary[type='submit']", text: 'Delete'
    assert_selector "form.button_to[action='#{route.offer_path(@auction.offer_from_user(@user).uuid)}']"

    render_inline(Common::Buttons::ButtonTo::Component.new(
      title_caption: 'Delete', color: 'green', 
      href: route.offer_path(@auction.offer_from_user(@user).uuid),
      options: { method: :delete, form_attributes:  { data: { turbo_confirm: confirmation_iternalization } }})
    )
    assert_selector "form.button_to button.c-login__button.c-btn.c-btn--green[type='submit']", text: 'Delete'
    assert_selector "form.button_to[action='#{route.offer_path(@auction.offer_from_user(@user).uuid)}']"

    render_inline(Common::Buttons::ButtonTo::Component.new(
      title_caption: 'Delete', color: 'blue',
      href: route.offer_path(@auction.offer_from_user(@user).uuid),
      options: { method: :delete, form_attributes:  { data: { turbo_confirm: confirmation_iternalization } }})
    )
    assert_selector "form.button_to button.c-login__button.c-btn.c-btn--blue[type='submit']", text: 'Delete'
    assert_selector "form.button_to[action='#{route.offer_path(@auction.offer_from_user(@user).uuid)}']"

    render_inline(Common::Buttons::ButtonTo::Component.new(
      title_caption: 'Delete', color: 'orange',
      href: route.offer_path(@auction.offer_from_user(@user).uuid),
      options: { method: :delete, form_attributes:  { data: { turbo_confirm: confirmation_iternalization } } })
    )
    assert_selector "form.button_to button.c-login__button.c-btn.c-btn--orange[type='submit']", text: 'Delete'
    assert_selector "form.button_to[action='#{route.offer_path(@auction.offer_from_user(@user).uuid)}']"

    render_inline(Common::Buttons::ButtonTo::Component.new(
      title_caption: 'Delete', color: 'black',
      href: route.offer_path(@auction.offer_from_user(@user).uuid),
      options: { method: :delete, form_attributes:  { data: { turbo_confirm: confirmation_iternalization } } })
    )
    assert_selector "form.button_to button.c-login__button.c-btn.c-btn--black[type='submit']", text: 'Delete'
    assert_selector "form.button_to[action='#{route.offer_path(@auction.offer_from_user(@user).uuid)}']"
  end

  def test_nested_button_colorize
    @user = users(:participant)
    @auction = auctions(:valid_with_offers)

    render_inline(Common::Buttons::ButtonTo::Component.new(
      title_caption: nil, color: 'ghost',
      href: route.offer_path(@auction.offer_from_user(@user).uuid), 
      options: { method: :delete, form_attributes:  { data: { turbo_confirm: confirmation_iternalization } } })
    ) do
      'delete'
    end
    assert_selector "form.button_to button.c-btn--icon.c-btn.c-btn--ghost[type='submit']", text: 'delete'

    render_inline(Common::Buttons::ButtonTo::Component.new(
      title_caption: nil, color: 'blue-secondary',
      href: route.offer_path(@auction.offer_from_user(@user).uuid),
      options: { method: :delete, form_attributes:  { data: { turbo_confirm: confirmation_iternalization } } })
    ) do
      'delete'
    end
    assert_selector "form.button_to button.c-btn--icon.c-btn.c-btn--blue-secondary[type='submit']", text: 'delete'

    render_inline(Common::Buttons::ButtonTo::Component.new(
      title_caption: nil, color: 'green',
      href: route.offer_path(@auction.offer_from_user(@user).uuid),
      options: { method: :delete, form_attributes:  { data: { turbo_confirm: confirmation_iternalization } } })
    ) do
      'delete'
    end
    assert_selector "form.button_to button.c-btn--icon.c-btn.c-btn--green[type='submit']", text: 'delete'

    render_inline(Common::Buttons::ButtonTo::Component.new(
      title_caption: nil, color: 'blue',
      href: route.offer_path(@auction.offer_from_user(@user).uuid),
      options: { method: :delete, form_attributes:  { data: { turbo_confirm: confirmation_iternalization } } })
    ) do
      'delete'
    end
    assert_selector "form.button_to button.c-btn--icon.c-btn.c-btn--blue[type='submit']", text: 'delete'

    render_inline(Common::Buttons::ButtonTo::Component.new(
      title_caption: nil, color: 'orange',
      href: route.offer_path(@auction.offer_from_user(@user).uuid),
      options: { method: :delete, form_attributes:  { data: { turbo_confirm: confirmation_iternalization } } })
    ) do
      'delete'
    end
    assert_selector "form.button_to button.c-btn--icon.c-btn.c-btn--orange[type='submit']", text: 'delete'

    render_inline(Common::Buttons::ButtonTo::Component.new(
      title_caption: nil, color: 'black',
      href: route.offer_path(@auction.offer_from_user(@user).uuid),
      options: { method: :delete, form_attributes:  { data: { turbo_confirm: confirmation_iternalization } } })
    ) do
      'delete'
    end
    assert_selector "form.button_to button.c-btn--icon.c-btn.c-btn--black[type='submit']", text: 'delete'
  end

  private

  def confirmation_iternalization
    I18n.t("pages.auction.auction_action_button.edit_and_remove_blind_offer.component.confirm_delete")
  end
end
