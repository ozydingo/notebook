require 'minitest/autorun'

class FooTest < Minitest::Test
  def test_text_includes
    assert_includes "hello", "ell", "wat?"
  end
end
