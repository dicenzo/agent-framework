# Command: Create Guerrilla Campaign

## Description
Generate a zero-budget guerrilla campaign for **{product_name}** targeting a specific audience on a specific platform, with copy, asset ideas, schedule, outreach, automation tips, and KPIs.

## Parameters
- product_name: string
- category: string
- landing_url: string
- primary_audience: string (ICP)
- platform: string (e.g., Reddit, Discord, X/Twitter, IndieHackers, niche forum)
- timeframe: string (e.g., "7 days")
- style: string (e.g., "educational", "meme-heavy", "case-study", "story-first")
- key_value_prop: string (tight benefit statement)
- proof_assets: string[] (e.g., ["15s GIF", "before/after screenshot"])
- constraints (optional): string (legal/brand/store rules)
- **ice_score: object** (impact: 1-10, confidence: 1-10, ease: 1-10)

## Output Structure
1) **Overview**  
   - Campaign name, one-sentence objective, primary hook(s)
   - **ICE Score breakdown and rationale**
   - **Hypothesis statement and expected outcomes**

2) **Channel Plan**  
   - Specific communities/servers/hashtags with rationale and posting windows  
   - Participation plan (value-first posts, reply cadence)
   - **Risk assessment and mod-approval strategy**
   - **Community rules and compliance requirements**

3) **Ready-to-Post Copy (platform-native)**  
   - 3 variations *per channel element* (short/medium/thread)  
   - Include one "no-link" value post and one "comment-link" variant
   - **A/B testing framework for copy variations**
   - **Platform-specific tone and format guidelines**

4) **Lightweight Assets**  
   - Shot list / screenflow for GIF or 20–40s demo  
   - Meme angles (if applicable) with captions
   - **Asset creation timeline and tools needed**
   - **Asset optimization for each platform**

5) **Outreach Strategy**  
   - 10 micro-influencer or curator targets criteria + sample DM/email script  
   - Mod-approval message template
   - **Outreach sequence and follow-up strategy**
   - **Relationship building timeline**

6) **Schedule & Execution**  
   - Day-by-day plan with tasks in ≤45 min/day blocks
   - **Critical path and dependencies**
   - **Buffer time for unexpected issues**
   - **Review and optimization checkpoints**

7) **Automation & Tools**  
   - Free tools for scheduling, monitoring, scraping mentions, and UTMs
   - **Zapier/IFTTT workflow templates**
   - **Analytics setup and tracking**
   - **Content calendar and scheduling tools**

8) **KPIs & Review**  
   - Leading metrics to watch (CTR, saves, replies, click depth)  
   - Pass/fail thresholds; what to scale vs. kill next week
   - **Weekly review checklist and pivot criteria**
   - **Success metrics template with targets**

9) **Risk Mitigation**
   - Platform-specific compliance checklist
   - Crisis response templates
   - Backup strategies if primary approach fails
   - **Mod relationship building strategies**

10) **Resource Requirements**
    - Time investment per day
    - Skills needed vs. available
    - Tools and access requirements
    - **Team member responsibilities and handoffs**

## Platform Templates

### Reddit
- **Value Post Template**: "I built [tool] to solve [specific problem]. Here's how it works..."
- **Comment Link Template**: "Here's the link: [url] - let me know if you need help setting it up!"
- **Mod Approval**: "Hi mods, I created a tool that helps [community] with [problem]. Can I share a tutorial post?"
- **Participation Ratio**: 3:1 value posts before any promotion
- **Best Times**: Tuesday-Thursday 9-11 AM EST, Sunday evenings

### Discord
- **Resource Post**: "Free template: [description] - DM me if you want the full version"
- **Bot Integration**: "Would love to add a [feature] bot to help with [task]"
- **Channel Strategy**: Ask mods for #resources or #showcase slot
- **Approach**: Join as contributor, not promoter

### Twitter/X
- **Thread Starter**: "5 [problem] hacks I learned building [tool]:"
- **Quote Tweet**: "This is exactly why I built [tool] - here's how it solves [pain point]"
- **Hashtag Strategy**: #YouTubeTips, #CreatorEconomy, #Productivity
- **Best Times**: 8-10 AM, 12-2 PM, 7-9 PM EST

### YouTube/Shorts/TikTok
- **Demo Script**: "Problem → Aha moment → Result in 20-40 seconds"
- **Content Reuse**: Convert to GIF for Reddit, screenshots for Twitter
- **Hashtags**: #ProductivityHack, #TechTip, #CreatorTool

### Niche Forums/Newsletters
- **Tutorial Post**: "How I solved [problem] using [approach]"
- **Curator Pitch**: "Here's what's in it for your readers: [value proposition]"
- **Community Rules**: Always check self-promotion policies first

## Experimentation Framework
- **Hypothesis**: "If we [action] then [expected outcome] because [reasoning]"
- **Test Variables**: Copy tone, posting time, CTA placement, asset type
- **Success Criteria**: Minimum viable metrics to continue
- **Iteration Plan**: How to optimize based on results
- **A/B Testing**: Message variations, timing, and CTAs

## Compliance Checklist
- [ ] Read community rules and guidelines
- [ ] Check if self-promotion is allowed
- [ ] Prepare mod approval message
- [ ] Review FTC disclosure requirements
- [ ] Confirm brand voice alignment
- [ ] Test content with team members
- [ ] Verify landing page compliance
- [ ] Check for competitor mentions or conflicts

## Success Metrics Template
- **Primary KPI**: [specific metric with target]
- **Secondary KPIs**: [list of supporting metrics]
- **Leading Indicators**: [early signals to watch]
- **Pass/Fail Thresholds**: [clear criteria for decisions]
- **Review Schedule**: [when to evaluate and pivot]
- **Benchmark Data**: [industry standards for comparison]

## Risk Assessment Matrix
- **Low Risk**: Value-first posts, community participation
- **Medium Risk**: Soft CTAs, influencer outreach
- **High Risk**: Direct promotion, mass messaging
- **Mitigation**: Always start with low-risk approaches

## Example Invocation
Run a guerrilla campaign for:
- product_name: "MyApp"
- category: "Creator productivity"
- landing_url: "https://myapp.com"
- primary_audience: "Creators struggling with content organization"
- platform: "Reddit"
- timeframe: "7 days"
- style: "educational + case study"
- key_value_prop: "Organize your workflow in minutes"
- proof_assets: ["20s demo GIF", "before/after screenshot", "user testimonial"]
- ice_score: {"impact": 8, "confidence": 7, "ease": 6}
- constraints: "No paid promotion, must follow Reddit self-promotion rules"

## Expected Output Quality
- **Actionable**: Every recommendation should be executable within 24 hours
- **Measurable**: All activities should have clear success metrics
- **Scalable**: Successful tactics should have clear expansion paths
- **Compliant**: All suggestions should respect platform rules and legal requirements
- **Authentic**: Content should feel genuine, not promotional

