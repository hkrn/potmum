# frozen_string_literal: true
class CommentBuilder
  def initialize(article)
    @article = article
    @comment = Comment.new(article_id: article.id)
    @error = nil
  end

  attr_reader :comment
  attr_reader :article
  attr_reader :error

  def build(params)
    @comment.user = params.delete(:user)
    @comment.body = params.delete(:body)

    if @comment.valid?
      @comment.save
      notify(@comment) if @article.public_item?
      true
    else
      @error = @comment.errors
      false
    end
  end

  def notify(comment)
    return unless GlobalSetting.notify_slack?

    client = Notifiers::Slack.new(
      GlobalSetting.notify_slack_token,
      channel: GlobalSetting.notify_slack_channel,
      color: GlobalSetting.theme_colors.last,
      icon: GlobalSetting.notify_slack_icon
    )
    client.post(
      "『<#{comment.article.decorate.url}|#{ERB::Util.html_escape comment.article.title}>』にコメントが付きました。",
      comment.decorate
    )
  end
end
