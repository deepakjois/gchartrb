# Some core extensions
module Kernel
    def alias_attr_accessor *syms
        class_eval <<-end_eval
            alias #{syms.first.to_s} #{syms.last.to_s}
            alias #{syms.first.to_s}= #{syms.last.to_s}=
        end_eval
    end
end
