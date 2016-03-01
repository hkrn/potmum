module MarkdownRenderable
  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      def markdown_html
        render_result[:output].to_s
      end

      def markdown_toc_html
        render_result[:toc].to_s
      end

      def render_result
        @render_result ||= MarkdownRenderable.render(public_send(self.class.markdown_column_get) || '')
      end
    end
  end

  module ClassMethods
    def markdown_column(column)
      @_markdown_column = column
    end

    def markdown_column_get
      @_markdown_column
    end
  end

  def self.render(text)
    @processor ||= PotMarkdown::Processor.new
    @processor.call(text,
                    asset_root: '/assets',
                    base_url: '/@',
                    sanitize_use_external: GlobalSetting.use_external_widget?
                   )
  end
end
