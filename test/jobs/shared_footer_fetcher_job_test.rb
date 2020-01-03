require 'test_helper'

class SharedFooterFetcherJobTest < ActiveJob::TestCase
  def setup
    super
    @voog_site_url = settings(:voog_site_url)
    @voog_api_key = settings(:voog_api_key)
    @voog_site_fetching_enabled = settings(:voog_site_fetching_enabled)

    @voog_site_url.update!(value: 'https://test.url')
    @voog_api_key.update!(value: '123')
    @voog_site_fetching_enabled.update!(value: 'true')
  end

  def test_perform_now
    locales_body = [{"id":1,"code": "et"}, {"id":2,"code": "en"}]
    et_footer_html = '<footer class="site-footer"><center><h3>Now that\'s one nice et footer</h3></center></footer>'
    en_footer_html = '<footer class="site-footer"><center><h3>Now that\'s one nice en footer</h3></center></footer>'

    stub_request(:get, %r{admin/api/}).to_return(body: locales_body.to_json, status: 200, headers: {})
    stub_request(:get, %r{/et}).to_return(body: et_footer_html, status: 200, headers: {})
    stub_request(:get, %r{/en}).to_return(body: en_footer_html, status: 200, headers: {})

    SharedFooterFetcherJob.perform_now

    assert RemoteViewPartial.find_by(name: 'footer', locale: 'et').present?
    assert RemoteViewPartial.find_by(name: 'footer', locale: 'en').present?
  end

  def test_job_runnability_is_determined_by_setting_value
    assert SharedFooterFetcherJob.needs_to_run?

    @voog_site_fetching_enabled.update!(value: 'false')
    assert !SharedFooterFetcherJob.needs_to_run?
  end
end
