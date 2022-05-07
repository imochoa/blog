---
title: 0=0?
subtitle: Getting trolled by math
date: 2021-09-28T9:00:33+02:00
tags: ['basic math']
bigimg: [{ src: '/img/backgrounds/laura-skinner-348001.jpg' }]
draft: true
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
