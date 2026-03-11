# Example Datasets for Demo Infographics

Use this data when the user doesn't bring their own dataset,
or as a template for similar topics.
The data is embedded as **text description in the English image prompt**.

---

## Market Shares / Pie Chart

Topic: Market shares 2025
Values: Product A 42%, Product B 28%, Product C 19%, Others 11%

Prompt snippet:
```
Pie chart showing market shares 2025: Product A 42%, Product B 28%, Product C 19%, Others 11%.
```

---

## Time Series / Growth

Topic: Revenue development (M EUR)
Values: 2020: 100, 2021: 118, 2022: 134, 2023: 152, 2024: 171, 2025: 195
CAGR: 14.3%

Prompt snippet:
```
Line chart showing revenue growth from 100M EUR (2020) to 195M EUR (2025), CAGR 14.3%.
Key milestones labeled at each data point.
```

---

## Industry Comparison / Bar Chart

Topic: Industry growth year-over-year
Values: Technology 87%, Finance 74%, Healthcare 61%, Industry 55%, Retail 48%, Energy 39%

Prompt snippet:
```
Horizontal bar chart comparing industry growth YoY:
Technology 87%, Finance 74%, Healthcare 61%, Industry 55%, Retail 48%, Energy 39%.
```

---

## Demographics / User Base

Topic: Age distribution of user base
Values: 18–24: 11%, 25–34: 18%, 35–44: 22%, 45–54: 20%, 55–64: 16%, 65+: 13%

Prompt snippet:
```
Demographic bar chart showing user age distribution:
18-24 (11%), 25-34 (18%), 35-44 (22%), 45-54 (20%), 55-64 (16%), 65+ (13%).
```

---

## Regional Comparison / DACH+

Topic: DACH+ revenue by country (M EUR)
Values: Germany 100, Switzerland 45, France 67, Austria 38, Netherlands 29

Prompt snippet:
```
Regional comparison chart for DACH+ revenue in million EUR:
Germany 100M, Switzerland 45M, France 67M, Austria 38M, Netherlands 29M.
```

---

## AI & Digitalization (Government Context)

Topic: Digitalization level of government processes 2025
Areas: Document processing 78%, Citizen chat 65%, Application review 52%, Appointment booking 88%, Reporting 71%
KPIs: 12,400 applications/day, Processing time ↓67%, Error rate 0.3%, User satisfaction 4.2/5

Prompt snippet:
```
Government digitalization dashboard 2025.
Progress bars: Document Processing 78%, Citizen Chat 65%, Application Review 52%,
Appointment Booking 88%, Reporting 71%.
KPI tiles: 12,400 applications/day, processing time reduced 67%, error rate 0.3%, satisfaction 4.2/5.
```

---

## Project Status / Dashboard

Topic: Project status Q1 2025
Phases: Concept ✅ 100%, Design ✅ 100%, Development 🔄 60%, Testing ⏳ 0%, Rollout ⏳ 0%

Prompt snippet:
```
Project status dashboard Q1 2025.
Phase timeline: Concept (done 100%), Design (done 100%), Development (in progress 60%),
Testing (pending 0%), Rollout (pending 0%).
Progress bars with status icons.
```

---

## Using User Data

When the user provides a CSV or table, embed the values directly as a text list in the prompt:

```
Content: [Label 1]: [Value 1], [Label 2]: [Value 2], [Label 3]: [Value 3] ...
```
