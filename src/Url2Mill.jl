module Url2Mill
using HTTP, Mill, SparseArrays

function bagofstrings(ss, ngramparams;use_sparse_arrays = false)
	if isempty(ss) 
		ss = [""]
	end
	x = Mill.NGramMatrix(ss, ngramparams...)
	x = use_sparse_arrays ? SparseMatrixCSC(x) : x
	BagNode(ArrayNode(x), [1:length(ss)])
end

function parsequeries2(querystring, ngramparams; use_sparse_arrays = false)
	ss = map(s -> String.(split(s,"=")), querystring)
	ks = map(s -> s[1], ss)
	vs = map(s -> (length(s) > 1) ? s[2] : "", ss)
	kvs = map(x -> keyvalue(x..., ngramparams;use_sparse_arrays), zip(ks,vs))
	kvs = reduce(catobs, kvs)
	BagNode(kvs, [1:Mill.nobs(kvs)])
end

function keyvalue(k, v, ngramparams; use_sparse_arrays = false)
	if use_sparse_arrays
		ProductNode((
			key = ArrayNode(SparseMatrixCSC(Mill.NGramMatrix([k], ngramparams...))), 
			value = ArrayNode(SparseMatrixCSC(Mill.NGramMatrix([v], ngramparams...))),
		))
	else
		ProductNode((
			key = ArrayNode(Mill.NGramMatrix([k], ngramparams...)), 
			value = ArrayNode(Mill.NGramMatrix([v], ngramparams...)),
		))
	end
end

function url2mill(s::AbstractString; ngramparams = (3,256, 2053), use_sparse_arrays = false)
	# @show s
	h = HTTP.URI(s)
	i = findfirst('/', h.path)
	j = findfirst('?', h.path)

	host = h.host
	path = h.path
	query = h.query
	if i === nothing
		host = path
		path = ""
	else
		host = path[1:i-1]
		path = path[i+1:end]
	end
	ProductNode((
		hostname = bagofstrings(String.(split(host,".")), ngramparams; use_sparse_arrays),
		path = bagofstrings(filter(!isempty, String.(split(path,"/"))), ngramparams; use_sparse_arrays),
		query = parsequeries2(String.(split(query,"&")), ngramparams; use_sparse_arrays),
	))
end

url2mill(ss::Vector{T}) where {T<:AbstractString} = reduce(catobs, map(url2mill2, ss))

function parsequeries(querystring, ngramparams)
	ss = map(s -> String.(split(s,"=")), querystring)
	ProductNode((
		key = bagofstrings(map(s -> s[1], ss), ngramparams),
		value = bagofstrings(map(s -> (length(s) > 1) ? s[2] : s[1][0:-1], ss), ngramparams),
		))
end
export url2mill
end