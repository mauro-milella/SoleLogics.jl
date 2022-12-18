using Random

export generate

"""
    TODO: add documentation after refining the function.

    Notes:

    * Using Vector{AbstractOperator} seems the only possible correct type here.
        There is no way to do Vector{<SomeConcreteType>}.
        Also, should this be Vector{<:AbstractOperator}? Here it should be the same.

    * If the alphabet is not iterable, this function should not work.
        The message in the thrown error is repeated (see general.jl)
"""
function generate(
    height::Int,
    alphabet::AbstractAlphabet,
    operators::Vector{<:AbstractOperator};
    rng::Union{Integer, AbstractRNG}=Random.GLOBAL_RNG
)
    if !isiterable(alphabet)
        return error("Please, provide method propositions(::$(typeof(a))).")
    end

    rng = (typeof(rng) <: Integer) ? Random.MersenneTwister(rng) : rng

    return _generate(height, alphabet, operators, rng=rng)
end

@boundscheck function _generate(
    height::Int,
    alphabet::AbstractAlphabet,
    operators::Vector{<:AbstractOperator};
    rng::Union{Integer, AbstractRNG}=Random.GLOBAL_RNG
)
    if height == 0
        return SyntaxTree(rand(rng, propositions(alphabet)))
    end

    op = rand(rng, operators)

    # TODO: split on more rows
    return SyntaxTree(op,
        Tuple([_generate(height-1, alphabet, operators; rng=rng) for _ in 1:arity(op)]))
end

#= Fast REPL test

alphabet = ExplicitAlphabet(Proposition.([1,2]))
operators = [NEGATION, CONJUNCTION, IMPLICATION]
generate(5, alphabet, operators)

=#