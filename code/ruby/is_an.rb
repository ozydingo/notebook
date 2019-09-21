GrammarError = Class.new(StandardError)

module GrammarNazi
  def is_an?(klass)
    raise(GrammarError, "Surely you mean 'is_a', right?") if /[aeiou]/i !~ klass.to_s[0]
    Kernel.instance_method(:is_a?).bind(self).call(klass)
  end

  def is_a?(klass)
    raise(GrammarError, "Surely you mean 'is_an', right?") if /[aeiou]/i =~ klass.to_s[0]
    super
  end
end

Object.include(GrammarNazi)
