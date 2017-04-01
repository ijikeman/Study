class Queuing
  def init
    @q = Queue.new
    @q
  end

  def self.q
    @q ||= init
  end
end
