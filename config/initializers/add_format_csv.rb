ActionController::Renderers.add :csv do |csv, options|
  # See: 
  # http://www.savagevines.com/post/2011/9/15/export_data_as_csv_with_rails_3_and_ruby_192/
  self.content_type ||= Mime::CSV
  self.response_body  = csv.respond_to?(:to_csv) ? csv.to_csv : csv
end
