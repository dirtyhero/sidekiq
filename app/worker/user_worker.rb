class UserWorker
  include Sidekiq::Worker

  def perform user_id, point
    user = User.find_by_id user_id
    return unless user
    destroy_jobs user_id, point
    user.increment! :point, point
  end

  def destroy_jobs user_id, point
    jobs = Sidekiq::ScheduledSet.new.select do |retri|
      retri.klass == self.class.name && retri.item["args"] == [user_id, point]
    end
    jobs.each(&:delete)
  end
end
