---
title: 0=0?
subtitle: Getting trolled by math
date: 2021-09-28T9:00:33+02:00
tags: ['basic math']
bigimg: [{ src: '/img/backgrounds/laura-skinner-348001.jpg' }]
draft: false
---

<!-- https://katex.org/docs/supported.html !-->
<!-- https://katex.org/docs/autorender.html -->

We've all been there, you're in the middle of an exam solivng a system of equations, lots of terms are disappearing and when the smoke clears you're left with a ground-breaking discovery...

$$
0=0
$$

Wait, what? 🤔

## What does 0=0 mean?

Long story short, it just means that you wrote something which was self-evident,
although maybe not to you at that time 👀

For instance if you a system of equations like:

{{<rawhtml>}}

$$
\begin{rcases}
x+y&=5 \\
2x+2y&=10
\end{rcases}
$$

{{</rawhtml>}}

You might try to isolate $y$ in the first equation:

$$y=5-x$$

and introduce it in the second:

{{<rawhtml>}}

$$
\begin{align*}
2x + 2(5-x)&=10 \\
2x -2x +10 &=10 \\
10&=10 \\
0&=10-10 \\
0&=0
\end{align*}
$$

{{</rawhtml>}}

The issue here is that both equations are actually the same equation with different scaling,
so the subsitution backfires because it does not add any new information.

In other words, because the equations are _linearly dependent_.

## 0=0 is always there

If you think about it, whenever you have any equality like:

$$ f(x,y,z,a,b,c,u,v,w) = \text{another crazy thing} $$

You know that they're equal so if you subtract either one from both sides,
you're going to end up with a big fat $0=0$

It's the same as adding $+1$ to either side and saying that they're still equal,
with the slight difference that:

$$f(x,y,z,a,b,c,u,v,w) +1 = \text{another crazy thing}+1 $$

is still a mystery whereas $0=0$ is "technically solved"
