require 'cases/helper'
require 'models/contact'
require 'models/sheep'
require 'models/track_back'
require 'models/blog_post'

class NamingTest < ActiveModel::TestCase
  def setup
    @model_name = ActiveModel::Name.new(Post::TrackBack)
  end

  def test_singular
    assert_equal 'post_track_back', @model_name.singular
  end

  def test_plural
    assert_equal 'post_track_backs', @model_name.plural
  end

  def test_element
    assert_equal 'track_back', @model_name.element
  end

  def test_collection
    assert_equal 'post/track_backs', @model_name.collection
  end

  def test_partial_path
    assert_equal 'post/track_backs/track_back', @model_name.partial_path
  end

  def test_human
    assert_equal 'Track back', @model_name.human
  end
end

class NamingWithNamespacedModelInIsolatedNamespaceTest < ActiveModel::TestCase
  def setup
    @model_name = ActiveModel::Name.new(Blog::Post, Blog)
  end

  def test_singular
    assert_equal 'blog_post', @model_name.singular
  end

  def test_plural
    assert_equal 'blog_posts', @model_name.plural
  end

  def test_element
    assert_equal 'post', @model_name.element
  end

  def test_collection
    assert_equal 'blog/posts', @model_name.collection
  end

  def test_partial_path
    assert_equal 'blog/posts/post', @model_name.partial_path
  end

  def test_human
    assert_equal 'Post', @model_name.human
  end

  def test_route_key
    assert_equal 'posts', @model_name.route_key
  end

  def test_param_key
    assert_equal 'post', @model_name.param_key
  end

  def test_recognizing_namespace
    assert_equal 'Post', Blog::Post.model_name.instance_variable_get("@unnamespaced")
  end
end

class NamingWithNamespacedModelInSharedNamespaceTest < ActiveModel::TestCase
  def setup
    @model_name = ActiveModel::Name.new(Blog::Post)
  end

  def test_singular
    assert_equal 'blog_post', @model_name.singular
  end

  def test_plural
    assert_equal 'blog_posts', @model_name.plural
  end

  def test_element
    assert_equal 'post', @model_name.element
  end

  def test_collection
    assert_equal 'blog/posts', @model_name.collection
  end

  def test_partial_path
    assert_equal 'blog/posts/post', @model_name.partial_path
  end

  def test_human
    assert_equal 'Post', @model_name.human
  end

  def test_route_key
    assert_equal 'blog_posts', @model_name.route_key
  end

  def test_param_key
    assert_equal 'blog_post', @model_name.param_key
  end
end

class NamingWithSuppliedModelNameTest < ActiveModel::TestCase
  def setup
    @model_name = ActiveModel::Name.new(Blog::Post, nil, 'Article')
  end

  def test_singular
    assert_equal 'article', @model_name.singular
  end

  def test_plural
    assert_equal 'articles', @model_name.plural
  end

  def test_element
    assert_equal 'article', @model_name.element
  end

  def test_collection
    assert_equal 'articles', @model_name.collection
  end

  def test_partial_path
    assert_equal 'articles/article', @model_name.partial_path
  end

  def test_human
    'Article'
  end

  def test_route_key
    assert_equal 'articles', @model_name.route_key
  end

  def test_param_key
    assert_equal 'article', @model_name.param_key
  end
end

class NamingHelpersTest < Test::Unit::TestCase
  def setup
    @klass  = Contact
    @record = @klass.new
    @singular = 'contact'
    @plural = 'contacts'
    @uncountable = Sheep
    @route_key = 'contacts'
    @param_key = 'contact'
  end

  def test_to_model_called_on_record
    assert_equal 'post_named_track_backs', plural(Post::TrackBack.new)
  end

  def test_singular
    assert_equal @singular, singular(@record)
  end

  def test_singular_for_class
    assert_equal @singular, singular(@klass)
  end

  def test_plural
    assert_equal @plural, plural(@record)
  end

  def test_plural_for_class
    assert_equal @plural, plural(@klass)
  end

  def test_route_key
    assert_equal @route_key, route_key(@record)
  end

  def test_route_key_for_class
    assert_equal @route_key, route_key(@klass)
  end

  def test_param_key
    assert_equal @param_key, param_key(@record)
  end

  def test_param_key_for_class
    assert_equal @param_key, param_key(@klass)
  end

  def test_uncountable
    assert uncountable?(@uncountable), "Expected 'sheep' to be uncoutable"
    assert !uncountable?(@klass), "Expected 'contact' to be countable"
  end

  private
    def method_missing(method, *args)
      ActiveModel::Naming.send(method, *args)
    end
end
