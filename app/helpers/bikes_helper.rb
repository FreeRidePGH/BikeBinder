module BikesHelper
  
  def number_label(bike)
    return sprintf("%05d", bike.number)
  end

end
