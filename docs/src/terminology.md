# Terminology

## [Atlas](@id term_atlas)

An **atlas for $M$** is a collection of [charts](@ref term_chart) whose domains cover $M$. An atlas
$\mathcal{A}$ is called a **smooth atlas** if any two charts in $$\mathcal{A}$$ are [smoothly compatible](@ref term_smoothly_compatible) with each other.

## [Chart](@id term_chart)

A **coordinate chart** (or just a chart) on $M$ is a pair $(U, \varphi)$, where $U$ is an open subset of $M$ and $\varphi: U\to \hat{U}$ is a [homeomorphism](@ref term_homeomorphism) from $U$ to an open subset $\hat{U} =\varphi(U) \subseteq \mathbb{R}^n$.

If $\varphi(p) = 0$, we say the chart is **centered at $p$**.

Given a chart $(U, \varphi)$, we call the set $U$ a **coordinate domain**, or **coordinate neighborhood** of each of its points. The map $\varphi$ is called a **(local) coordinate map**, and the component functions $(x^1, x^2, \dots, x^n)$ of $\varphi$, defined by $\varphi(p) = \large(x^1(p), x^2(p), \dots, x^n(p)\large)$, are called **local coordinates** on $U$.

## [Homeomorphism](@id term_homeomorphism)

A function $f:X\to Y$ between two topological spaces is a homeomorphism if it has the following properties:

* f is a bijection (one-to-one and onto).
* f is continuous.
* the inverse function f⁻¹ is continuous.

## [Diffeomorphism](@id term_diffeomorphism)

If $U$ and $V$ are open subsets of Euclidean spaces $\mathbb{R}^n$ and $\mathbb{R}^m$, respectively, a function $F: U \to V$ is said to be **smooth** if each of its component functions has continuous partial derivatives of all orders. If in addition $F$ is bijective and has a smooth inverse map, it is called a **diffeomorphism**. A diffeomorphism is, in particular, a [homeomorphism](@ref term_homeomorphism)

## [Smoothly compatible](@id term_smoothly_compatible)

Two [charts](@ref term_chart) $(U, \varphi)$, $(V, \psi)$ are said to be smoothly compatible if either $U \cap V = \varnothing$ or the transition map $\psi\circ\varphi^{-1}$ is a [diffeomorphism](@ref term_diffeomorphism).
