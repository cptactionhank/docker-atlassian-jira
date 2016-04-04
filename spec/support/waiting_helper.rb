module WaitingHelper
  def wait_for_ajax
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def wait_for_document
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until document_ready?
    end
  end

  def wait_for_page
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_ajax_requests? && document_ready?
    end
  end

  def wait_for_location_change
    original = current_url
    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until location_changed? original
    end
  end

  private

  def finished_all_ajax_requests?
    page.evaluate_script('AJS.$.active').zero?
  end

  def document_ready?
    page.evaluate_script('document.readyState === "complete"')
  end

  def location_changed?(url)
    !url.eql? current_url
  end
end
