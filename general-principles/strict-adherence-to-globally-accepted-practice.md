# Strict Adherence To Globally Accepted Practice

I'm a data modeling purist. The reason for that is if the data is not modeled properly, nothing downstream will work right.

100 million year ago, I purchased The Data Warehouse Toolkit by Ralph Kimball and it's been my go to resource for data modeling dimensional systems ever since. At this point in my career, I don't need to use the book as a reference unless I need it to make an argument. Even after all this time and all my experience I still need to point to Ralph as an authority even though I am a clear authority myself.

The reason why I have to frequently use that book as an authority is because often in organizations there is either very little organic knowledge on dimensional modeling, or there is pressure to create suboptimal solutions in the interest of just making things work. In the case of the former, I often find myself having to run arguments for or education people on basic dimensional modeling techniques. In the case of the latter, this is a harder argument to win.

I have so much experience that I have basically turned clairvoyant. I create things that solve problems that organizations do not even know they will have and they never will because I solved it before it ever became a problem. That is one of the things the framework will help you do. It is designed to take into account any number of potential data challenges. However, trying to explain to a CIO what I see in a crystal ball is often met with intense skepticism powered by the need to get things up and running. While understandable, when people take a "just make it work" approach to data modeling,  they are essentially mortgaging the future to finance short term gains. That play is always a loser.

Another challenge is that a lot of organizations think they are facing unique challenges. This is almost always not the case. The problem most organizations are trying to solve is data is over there and it needs to be over here. It is that simple. The solution set to that problem is solved by this framework. It is general enough that it can be applied to most data warehouse load problems. Despite that, you will still run into managers that insist on doing their special thing because their special. The problem with that goes back to my original assertation of if the data is not modeled properly, nothing downstream will work right.

I consider Kimball's work the global standard for dimensional modeling. I am not alone. Many BI tools expect a dimensional model when you connect them to the data warehouse. They expect facts and dimensions. They expect your fact tables to be all at the same grain. They expect your dimensions to carry filter information. If that is not the case, then your BI tool will not work right, and, as I have already talked about, it is important that your data warehouse be a part of that ecosystem not just a standalone tool.

Special note. This is important and I'm going to stick it right here for now until I can write more on the topic later.

**You do not EVER store data based on the layout of some report.**

That is what the semantic layer is for.



