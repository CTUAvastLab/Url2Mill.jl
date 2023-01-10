using Mill, Url2Mill, HTTP,
using Test
@testset "parsing to string" begin 
	domain = ["st","360buyimg","com"]
	path = ["m","css","2014","index","home_2017_5_9.css"]
	
	ds = url2mill("st.360buyimg.com/m/css/2014/index/home_2017_5_9.css?v=jd201705182030")
	@test ds[:hostname].data.data.S == domain
	@test ds[:path].data.data.S == path
	@test ds[:query].data[:key].data.S == ["v"]
	@test ds[:query].data[:value].data.S == ["jd201705182030"]

	ds = url2mill("st.360buyimg.com?v=jd201705182030")
	@test ds[:hostname].data.data.S == domain
	@test ds[:path].data.data.S == [""]
	@test ds[:query].data[:key].data.S == ["v"]
	@test ds[:query].data[:value].data.S == ["jd201705182030"]

	ds = url2mill("st.360buyimg.com")
	@test ds[:hostname].data.data.S == domain
	@test ds[:path].data.data.S == [""]
	@test ds[:query].data[:key].data.S == [""]
	@test ds[:query].data[:value].data.S == [""]

	ds = url2mill("st.360buyimg.com/m/css/2014/index/home_2017_5_9.css")
	@test ds[:hostname].data.data.S == domain
	@test ds[:path].data.data.S == path
	@test ds[:query].data[:key].data.S == [""]
	@test ds[:query].data[:value].data.S == [""]
end

@testset "parsing to matrix" begin 
	domain = SparseMatrixCSC(NGramMatrix(["st","360buyimg","com"]))
	path = SparseMatrixCSC(NGramMatrix(["m","css","2014","index","home_2017_5_9.css"]))
	ks = SparseMatrixCSC(NGramMatrix(["v"]))
	vs = SparseMatrixCSC(NGramMatrix(["jd201705182030"]))
	es = SparseMatrixCSC(NGramMatrix([""]))
	
	ds = url2mill("st.360buyimg.com/m/css/2014/index/home_2017_5_9.css?v=jd201705182030";use_sparse_arrays = true)
	@test ds[:hostname].data.data == domain
	@test ds[:path].data.data == path
	@test ds[:query].data[:key].data == ks
	@test ds[:query].data[:value].data == vs

	ds = url2mill("st.360buyimg.com?v=jd201705182030";use_sparse_arrays = true)
	@test ds[:hostname].data.data == domain
	@test ds[:path].data.data == es
	@test ds[:query].data[:key].data == ks
	@test ds[:query].data[:value].data == vs

	ds = url2mill("st.360buyimg.com";use_sparse_arrays = true)
	@test ds[:hostname].data.data == domain
	@test ds[:path].data.data == es
	@test ds[:query].data[:key].data == es
	@test ds[:query].data[:value].data == es

	ds = url2mill("st.360buyimg.com/m/css/2014/index/home_2017_5_9.css";use_sparse_arrays = true)
	@test ds[:hostname].data.data == domain
	@test ds[:path].data.data == path
	@test ds[:query].data[:key].data == es
	@test ds[:query].data[:value].data == es
end