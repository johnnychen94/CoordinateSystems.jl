# This is expected to be added to Julia (maybe under a different name)
# Follow https://github.com/JuliaLang/julia/issues/35543 for progress
basetype(T::Type) = Base.typename(T).wrapper # Note: this adds about 3ns overhead
basetype(T) = basetype(typeof(T))
