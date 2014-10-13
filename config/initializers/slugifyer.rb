class Slugifyer
  def self.slugify(string)
    string.strip.gsub(/\s/, '_').gsub(/([^A-Za-z0-9_\-])/,'_').downcase
  end
end