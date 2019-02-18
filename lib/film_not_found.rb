class FilmNotFound < StandardError
  def initialize(data)
    @data = data
  end
end
