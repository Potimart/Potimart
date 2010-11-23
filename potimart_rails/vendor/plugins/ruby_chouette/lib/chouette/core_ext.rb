class Hash
  def rename_keys(renaming)
    dup.rename_keys!(renaming)
  end

  def rename_keys!(renaming)
    renaming.each_pair do |old_key, new_key|
      rename_key!(old_key, new_key)
    end
    self
  end

  def rename_key!(old_key, new_key)
    self[new_key] = self.delete(old_key) if self.has_key?(old_key)
    self
  end
end

module Kernel
  def qualified_const_get(str)
    path = str.to_s.split('::')
    from_root = path[0].empty?
    if from_root
      from_root = []
      path = path[1..-1]
    else
      start_ns = ((Class === self)||(Module === self)) ? self : self.class
      from_root = start_ns.to_s.split('::')
    end
    until from_root.empty?
      begin
        return (from_root+path).inject(Object) { |ns,name| ns.const_get(name) }
      rescue NameError
        from_root.delete_at(-1)
      end
    end
    path.inject(Object) { |ns,name| ns.const_get(name) }
  end
end

