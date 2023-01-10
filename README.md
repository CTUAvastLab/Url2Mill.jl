# Url2Mill.jl
An extension of Mill.jl to convert URLs to Mill structure


A simple library implementing representation of URLs from the paper ![Nested Multiple Instance Learning in Modelling of HTTP network traffic, Tomas Pevny, Marek Dedic, 2020](https://arxiv.org/abs/2002.04059)

Example:
```julia
using Url2Mill

julia> ds = url2mill("st.360buyimg.com/m/css/2014/index/home_2017_5_9.css?v=jd201705182030")
ProductNode  # 1 obs, 152 bytes
  ├── hostname: BagNode  # 1 obs, 104 bytes
  │               ╰── ArrayNode(2053×3 NGramMatrix with Int64 elements)  # 3 obs, 166 bytes
  ├────── path: BagNode  # 1 obs, 104 bytes
  │               ╰── ArrayNode(2053×5 NGramMatrix with Int64 elements)  # 5 obs, 214 bytes
  ╰───── query: BagNode  # 1 obs, 136 bytes
                  ╰── ProductNode  # 1 obs, 64 bytes
                        ├──── key: ArrayNode(2053×1 NGramMatrix with Int64 elements)  # 1 o ⋯
                        ╰── value: ArrayNode(2053×1 NGramMatrix with Int64 elements)  # 1 o ⋯

```
If you want to represent strings by ngrams directly as `SparseArrays`, use `use_sparse_arrays = true`
```julia
julia> ds = url2mill("st.360buyimg.com/m/css/2014/index/home_2017_5_9.css?v=jd201705182030";use_sparse_arrays = true)
ProductNode  # 1 obs, 184 bytes
  ├── hostname: BagNode  # 1 obs, 112 bytes
  │               ╰── ArrayNode(2053×3 SparseMatrixCSC with Int64 elements)  # 3 obs, 552 b ⋯
  ├────── path: BagNode  # 1 obs, 112 bytes
  │               ╰── ArrayNode(2053×5 SparseMatrixCSC with Int64 elements)  # 5 obs, 888 b ⋯
  ╰───── query: BagNode  # 1 obs, 152 bytes
                  ╰── ProductNode  # 1 obs, 80 bytes
                        ├──── key: ArrayNode(2053×1 SparseMatrixCSC with Int64 elements)  # ⋯
                        ╰── value: ArrayNode(2053×1 SparseMatrixCSC with Int64 elements)  # ⋯
```
