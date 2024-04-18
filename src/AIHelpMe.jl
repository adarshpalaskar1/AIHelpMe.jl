module AIHelpMe

using Preferences, Serialization, LinearAlgebra, SparseArrays
using LazyArtifacts
using Base.Docs: DocStr, MultiDoc, doc, meta
using REPL: stripmd
using HDF5

using PromptingTools
using PromptingTools: pprint
using PromptingTools.Experimental.RAGTools
using PromptingTools.Experimental.RAGTools: AbstractRAGConfig, getpropertynested,
                                            setpropertynested, merge_kwargs_nested
using SHA: sha256, bytes2hex
using Logging, PrecompileTools
const PT = PromptingTools
const RT = PromptingTools.Experimental.RAGTools

## export remove_pkgdir, annotate_source, find_new_chunks
include("utils.jl")

## Globals and types are defined in here
include("pipeline_defaults.jl")

## export docdata_to_source, docextract, build_index
include("preparation.jl")

## export load_index!, update_index!
include("loading.jl")

export aihelp
include("generation.jl")

export @aihelp_str, @aihelp!_str
include("macros.jl")

function __init__()
    ## Set the active configuration
    update_pipeline!(:bronze)
    ## Load index - auto-loads into MAIN_INDEX
    load_index!(:julia)
end

# Enable precompilation to reduce start time, disabled logging
with_logger(NullLogger()) do
    @compile_workload include("precompilation.jl")
end

end
