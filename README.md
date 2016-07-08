# arch-enemy
Arch Linux installation, security hardening and automatic deployment setup scripts.

As many Arch Linux users will tell you the Distro itself is build around the concept of Keep it Simple Stupid (KISS).
Therefore by default it is minimal and bloat free as much as you want it to be and I like that about it. Bloat kills! 
Although as a distro I found it somewhat painstaking to make the changes I would need in order to get a fully functional 
system, up and running again after doing a reinstallion. Without typing in a mountain of commands and modifying loads of 
configuration files to get it how I wanted. That brings me to my next point. What did I want? 

Well I wanted something similar to Arch Linux on a desktop but secured and hardened inline with enterprise compliance standard 
such as PCI-DSS, ISO-27001, HIPAA and adhering to CIS benchmarks. Straight out of the box! No questions asked.
As a SysAdmin having done that sort of work at three companies in the past I am a bit tired of reinventing the wheel there. 
Besides knowing all that not being nearly enough to thwart off the most advanced and determined attackers.

That said I also find it disturbing that I could not find a single Linux Distro that was taking the OpenBSD approach of "Secure by default" 
into design consideration. It's always been the case that you install and then harden. Instead of hardened before install or by default.

In my oppinion this leaves a system vulnerable to potential exploitation during the very deployment phase. In an ever more 
dangerous world of Advanced Persistant Threats, Insider threats, Weapons Grade Malware and attacks targeting hardware manufactures
firmware. It's never been more important to change how we deploy systems and think about systems security. Not only that but as we shift 
in to a DevOps based approach of continuos intergration more needs to be done at securing systems not only on the application configuration 
layer but also the Kernel, Process, Container/VM and Hardware level.

One distro that is focusing on a lot of this is Qubes with it's Privilege seperation based off Xen Hypervisors. 
Yet it's still not enough in my mind. Privilege seperation and Anti-Ironmaid is a very good start however. 
Although there is still a lot more to be done in this regard. Perhaps Hybrid GrSec/Xen Kernels, Pax with Gradm RBAC need to be 
incorporated in to this approach including hardened application configurations and Lets just forget about MAC systems designed 
by Three Letter Agencies content in endangering there own citizens both domestically and abroad. 
Backdoored Dual_EC_DRBG anyone? Hardly a product of any reputable organisation.

So where and how do we proceed? Well we stack all the odds in our favour as much as possible and start designing systems with 
all the old security baselines and compliance configurations in consideration but also build on it even further as a community.
Do away with failing cryptographic standards, bad default configurations of applications. Start shipping systems with almost 
every application secured from the get go. Now I know that by looking at the Arch-Enemy scripts as of writing this you are probably
thinking well these are dead simple and probably not going to change the world and you might be right. 
Although understand this, it's the start of something much bigger and will most likely turn in to a Linux Distro as some point.
Despite just being a bunch of quick and dirty not yet Alpha worthy scripts to get something done.

# Need Support?
/k\ /e\ /i\ /t\ /h\ /.\ /s\ /m\ /i\ /t\ /h\ /@\ /u\ /n\ /s\ /e\ /e\ /n\ /.\ /i\ /s\
