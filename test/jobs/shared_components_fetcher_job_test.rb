require 'test_helper'

class SharedComponentsFetcherJobTest < ActiveJob::TestCase
  def setup
    super
    Setting.create!(code: 'voog_site_url', value: 'https://test.url', description: '123')
    Setting.create!(code: 'voog_api_key', value: '123', description: '123')
    Setting.create!(code: 'voog_site_fetching_enabled', value: 'true', description: '123')

  end

  def test_perform_now
    locales_body = [{"id":1,"code": "et"}, {"id":2,"code": "en"}]
    et_footer_html = '<footer class="site-footer"><center><h3>Now that\'s one nice et footer</h3></center></footer'
    en_footer_html = '<footer class="site-footer"><center><h3>Now that\'s one nice en footer</h3></center></footer'
    stub_request(:get, %r{admin/api/}).to_return(body: locales_body.to_json, status: 200, headers: {})
    stub_request(:get, %r{/et}).to_return(body: et_footer_html, status: 200, headers: {})
    stub_request(:get, %r{/en}).to_return(body: en_footer_html, status: 200, headers: {})

    SharedComponentsFetcherJob.perform_now
    assert File.exists? "storage/partials/footer_en.html"
    assert File.exists? "storage/partials/footer_et.html"
  end

  def test_job_runnability_is_determined_by_setting_value
    setting = Setting.find_by(code: 'voog_site_fetching_enabled')

    setting.update!(value: 'true')
    assert SharedComponentsFetcherJob.needs_to_run?

    setting.update!(value: 'false')
    assert !SharedComponentsFetcherJob.needs_to_run?
  end
end
