# EDUVISION-KE CBC Dataset Explanation

## Overview
This document explains the structure, purpose, and ethical considerations
of the CBC-aligned dataset used in the EDUVISION-KE MVP.

## Data Nature
The dataset is **synthetic and anonymized**, created solely for demonstration
and evaluation purposes within the AI Hackathon. No real learner data is used.

## Key Columns Description

- `county` – One of Kenya’s 47 counties for geographic equity analysis.
- `school_name` – Synthetic school identifier.
- `learner_id` – Anonymized learner identifier.
- `grade_level` – Learner’s current CBC grade.
- `cbc_performance_level` – Below Expectation, Meeting Expectation, Above Expectation, or Exceeding Expectation.
- `attendance_rate` – Learner attendance percentage.
- `assignment_completion` – Rate of completed assignments.
- `discipline_incidents` – Recorded discipline cases (synthetic).
- `socio_economic_risk` – Encoded socio-economic risk indicator.
- `county_context_factor` – Environmental or regional context affecting learning.
- `dropout_risk_flag` – AI-ready label for early warning detection.
- `talent_pathway` – Suggested talent pathway (STEM, Arts, Sports, Social Sciences).

## Intended Use
The dataset supports:
- Early warning of learner dropout risk
- Talent discovery beyond exam scores
- Explainable AI model development
- Equity-aware education analytics

## Ethics & Compliance
All data respects child protection, privacy, and Kenya Data Protection principles.
