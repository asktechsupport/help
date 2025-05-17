📄[Download the guide to tune Logic Monitor.xlsx](https://github.com/user-attachments/files/20266041/LogicMonitor_Alert_Tuning_Guide.xlsx)

How to

Setting alert fatigue tuning in **LogicMonitor** involves a few key steps depending on the type of alert and the data source. Below is a guide to **how to set these tuning rules**, using the LogicMonitor portal.

---

## 🔧 **How to Set or Tune Alerts in LogicMonitor**

---

### 🔁 **1. Use Dynamic Thresholds (for metrics with natural fluctuation)**

* **Go to**: *Settings* → *DataSources*
* **Find** the relevant DataSource (e.g., CPU Usage)
* **Edit** the DataSource → *Alert Thresholds*
* Click “Add Dynamic Threshold” → Choose “Standard Deviation” or “Historical Average”
* Set a **sensitivity level** (e.g., 2 std deviations over 1-hour window)

✅ **Use Case**: CPU spikes, bandwidth, latency

---

### 🔕 **2. Suppress Alerts on Specific Instances (e.g., unused interfaces, static disks)**

* **Go to**: *Resources* → Device → Instance
* Click the instance (e.g., eth0 or D:\Recovery Partition)
* **Edit instance** → uncheck *Alerting Enabled*
* Or set an instance-level **custom threshold** or disable noisy datapoints

✅ **Use Case**: Interface flaps, full system partitions, SNMP traps

---

### 🪜 **3. Add Alert Escalation Delay**

* **Go to**: *Settings* → *Escalation Chains*
* Create or edit an escalation chain
* Add a **Delay (in minutes)** before the alert is sent
* Example: Delay alerts by 5–10 minutes to filter out brief spikes

✅ **Use Case**: Temporary high CPU, packet loss, backup alerts

---

### 📶 **4. Tune Alert Thresholds (Globally or Per Group)**

* **Global**: Settings → DataSources → \[Your DataSource] → Alert Thresholds
* **Device Group Level**: Go to *Device Group* → *Manage Group Settings* → *Applies To* override
* **Custom Thresholds**: Set "Alert Thresholds" per device or group

✅ **Use Case**: Disk usage over 90%, memory thresholds

---

### 🔁 **5. Use Hysteresis (Auto-clear Conditions)**

* Within a DataSource's alert setting, configure:

  * **Trigger condition**: e.g., Disk usage > 90% for 5 min
  * **Clear condition**: e.g., Disk usage < 85% for 5 min
* Prevents "flapping" alerts when a metric toggles around the threshold

✅ **Use Case**: CPU/memory/disk bouncing near thresholds

---

### 📊 **6. Review Alert Frequency and History**

* Go to: *Reports* → *Alert Trend* or *Alert Frequency*
* Identify:

  * Repeating alerts
  * Devices generating excessive alerts
* Suppress or retune noisy sources

✅ **Use Case**: General alert fatigue analysis

---

### 🧩 **7. Use Dependency Mapping**

* Go to: *Resources* → *Topology* or *Dependency Settings*
* Map devices so that alerts **downstream are suppressed** if upstream is down

  * E.g., suppress VM alerts if ESXi host is down

✅ **Use Case**: Ping loss, device unreachable

---

### 📁 **8. Schedule Maintenance Windows**

* Go to: *Resources* → select device(s) → *Manage Scheduled Down Time*
* Suppress alerts during backups, patch windows, reboots

✅ **Use Case**: Backup job duration, frequent reboots

---



