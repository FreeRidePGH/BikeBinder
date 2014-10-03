# will first try and copy the file:
# config/deploy/#{full_app_name}/#{from}.erb
# to:
# shared/config/to
# if the original source path doesn exist then it will
# search in:
# config/deploy/shared/#{from}.erb
# this allows files which are common to all enviros to
# come from a single source while allowing specific
# ones to be over-ridden
# if the target file name is the same as the source then
# the second parameter can be left out
def smart_template(from, to=nil, opts = {})
  erb_gen = opts[:generator] || ERB
  force = opts[:force] || false
  full_to_path_root = opts[:full_to_path_root] || shared_path

  to ||= from
  full_to_path = "#{full_to_path_root}/#{to}"

  if !force && test("[ -f #{full_to_path} ]")
    # do nothing if the remote file already exists
    warn " Remote file #{full_to_path} already exists and will not be overriden"
  else
    if from_erb_path = template_file(from)
      from_erb = StringIO.new(erb_gen.new(File.read(from_erb_path)).result(binding))
      upload!(from_erb, full_to_path)
      info "copying: #{from_erb} to: #{full_to_path}"
    else
      error " File #{from} not found. Does it end in erb?"
    end
  end
end

def template_file(name)
  if File.exist?((file = "config/deploy/#{fetch(:full_app_name)}/#{name}.erb"))
    return file
  elsif File.exist?((file = "config/deploy/shared/#{name}.erb"))
    return file
  end
  return nil
end

