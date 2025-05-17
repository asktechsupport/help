
How to

Setting alert fatigue tuning in **LogicMonitor** involves a few key steps depending on the type of alert and the data source. Below is a guide to **how to set these tuning rules**, using the LogicMonitor portal.

---

## 🔧 **How to Set or Tune Alerts in LogicMonitor**

---

# LogicMonitor Alert Tuning – Updated Guide

## 1. Setting or Adjusting Alert Thresholds

Inside a DataSource:

- Go to the **Alert Tuning** tab or scroll to the datapoint section.
- Click a **datapoint** (e.g., `CPUUsage`, `DiskUsage`).
- Choose from:
  - **Static thresholds** (set Warning, Error, Critical levels).
  - **Dynamic thresholds** (enable thresholds based on historical data trends).

_Use for CPU, disk, memory, bandwidth, and latency alerts._

---

## 2. Tuning Alerts per Device or Group

- Navigate to **Resources**.
- Select a **Device** or **Device Group**.
- Click **Manage** → **Alert Tuning**.
- Override thresholds at:
  - Group level
  - Device level
  - Specific instance level

_Use for suppressing noisy interfaces, recovery partitions, or app-specific disk paths._

---

## 3. Suppressing or Disabling Specific Alerts

- In **Resources**, go to the target **Device** → **Instances**.
- Select the instance (e.g., a NIC or disk).
- Edit the instance:
  - Toggle **Alerting Enabled** off, or
  - Disable alerting on specific datapoints

_Use for unused ports, full system partitions, or known noisy metrics._

---

## 4. Setting Escalation Delays

- Go to **Settings** → **Escalation Chains**.
- Create or edit a chain.
- Set a **Delay** (e.g., 5–10 minutes before sending alerts).
- Assign this to alerts via:
  - **Settings** → **Alert Rules** → edit or create a rule → assign the escalation chain

_Use to reduce false positives from short spikes or flaps._

---

## 5. Configuring Hysteresis (Auto-Clear Logic)

Within a DataSource:

- Click on the relevant **Datapoint**.
- Go to **Advanced Settings**.
- Configure:
  - Trigger condition (e.g., `> 90%`)
  - Clear condition (e.g., `< 85%` for 5 minutes)

_Use to prevent alert flapping on metrics like disk space or CPU._

---

## 6. Using Dependency Mapping

- Go to **Resources**.
- Select a **parent device** (e.g., core switch or WAN gateway).
- Define **dependent devices**.
- When the parent is unreachable, suppress downstream alerts.

_Use to prevent cascading alerts during network or infrastructure issues._

---

## 7. Reviewing and Auditing Alerts

- Navigate to **Reports**.
- Create a new report and select:
  - **Alert Trend**: View alerts over time.
  - **Top Talkers**: Identify noisiest devices or metrics.

_Use for monthly or quarterly alert audits and tuning decisions._





