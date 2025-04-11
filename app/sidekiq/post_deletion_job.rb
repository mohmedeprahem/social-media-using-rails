class PostDeletionJob
  include Sidekiq::Job

  def perform(post_id)
    post = Post.find_by(id: post_id)
    post&.destroy
  end
end
