---
title: "Tuning and locking down a 126-VM vSphere environment"
date: 2026-11-19
draft: false
years: "2023-2026"
categories: ["vmware-vsphere", "solarwinds", "sql-server", "ad-ds", "cisco"]
tags: ["virtualization", "performance", "identity", "networking", "security"]
summary: "I measured before changing anything, then fixed how 27 servers saw their CPUs, cut an oversized monitoring server by 20 virtual CPUs, moved hypervisor admin rights onto one group, and stopped a network fault the switch logged about 350 times a day."
---

## The problem

I have run our VMware vSphere environment since 2023: 126 virtual machines across four sites. Over the years it picked up the habits most environments do. None of them caused an outage, but each one cost performance, licensing room or control.

- **Servers saw their CPUs the wrong way.** Many virtual machines were set up as several small virtual processors (sockets) instead of one, even though each fit easily inside one physical processor. That hides the host's memory layout from the server (NUMA, the rule that memory close to a processor is faster), and on database servers it can hit SQL Server's licensing limit on sockets. One plant-floor database server was sitting exactly on that limit, so any CPU added later would have been silently ignored.
- **The monitoring server was too big to run well.** It had 32 virtual CPUs but averaged about 20% use. A virtual machine that big has to wait for the host to free up that many physical cores at once, so it kept raising "CPU ready" alarms, which means it was waiting for the host instead of working. A setting that allows adding CPUs while running was also on, and that setting switches off the memory-layout awareness above.
- **Admin rights had built up for years.** Permissions in vCenter (the console that runs the whole environment) had grown one grant at a time.
- **A network fault nobody had traced.** At one site the core switch logged a server's address jumping between ports about 350 times a day.

## What I built

**Measured first.** I pulled 30 days of CPU history from vCenter before touching anything. CPU ready time was under 1.3% across the estate, so no server needed more or fewer CPUs. Only the layout changed, which meant no licensing or capacity impact.

**Fixed the CPU layout on 27 servers.** I moved each one to a single socket with the same number of cores. I did the first domain controller myself, then planned the rest in batches my team ran: one site's seven servers in one window, then the main site's 19 in three, with the domain controller alone first, the database servers after payroll had run, and everything else last. I left vendor appliances alone on purpose, because their vendors set those layouts.

**Right-sized the monitoring server.** I designed and made the change from 32 virtual CPUs to 12, in one socket, with hot-add switched off, so the whole server now fits inside one physical processor's memory. Memory stayed the same. My team checked it over several polling cycles before we called it done.

**Put hypervisor admin rights onto one group.** I reviewed every permission entry against 90 days of sign-in history. Admin access now comes from one group that holds only dedicated admin accounts, in line with our tiered admin model. Everyday email accounts and one-off personal grants are gone. Before removing the old group, I found a Wi-Fi sign-in dependency on it and kept the group itself so nothing broke.

**Traced the network fault to a mismatch between host and switch.** The host spread traffic over four network links using a mode that expects the switch to bundle those links together, and the switch didn't. I matched the jumping address to one server's adapter, mapped the host's links to switch ports with CDP (Cisco's neighbor discovery), and compared both configs. I chose to fix it on the host side, switching to VMware's default teaming mode, rather than reconfigure a switch that is due to be replaced. My team made the change with no downtime.

**Kept a second switch problem separate.** The same switch was running its processor at 98-99%. That wasn't the teaming issue: I traced it to a known Cisco bug where processor load creeps up over years of uptime. I reloaded the switch stacks myself and planned the software upgrade that removes the bug.

## What changed

- **27 servers** now see one CPU socket each, with no failed restarts and no change to CPU counts.
- **The monitoring server gave 20 virtual CPUs back** to the cluster, and its CPU ready alarms stopped.
- **No everyday account can administer the hypervisor.** Admin rights come from one group of dedicated admin accounts.
- **The address-jumping fault went from about 350 a day to zero** the moment the teaming change landed.
- **The switch processor dropped from 98-99% to 2-3%** after the reload. That was a separate fix from the teaming change.

## Skills

vSphere CPU scheduling and vNUMA · right-sizing from performance data · SQL Server licensing awareness · least-privilege access in vCenter · tiered admin model · vSwitch teaming vs. switch link bundling · CDP-based physical mapping · Cisco switch troubleshooting · batched change windows with rollback plans · writing steps a team can run
