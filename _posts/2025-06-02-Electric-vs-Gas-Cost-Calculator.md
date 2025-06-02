---
layout: post
title: Electric vs Gas Car Cost Calculator
comments: true
tags: Electric Gas Car Fuel cost calculator
---
<head>
  <style>
    input { width: 100px; margin-right: 10px; }
    button { padding: 0.5rem 1rem; margin-top: 1rem; }
    .result { margin-top: 1rem; font-size: 1.2rem; font-weight: bold; }

    table {
      margin-top: 2rem;
      border-collapse: collapse;
      width: 100%;
      text-align: center;
    }
    th, td {
      border: 1px solid #ccc;
      padding: 0.5rem;
    }
    th {
      background: #f4f4f4;
    }
    .electric { background-color: #d0f0c0; }
    .gas { background-color: #ffd0d0; }
    .equal { background-color: #f0f0a0; }
  </style>
</head>

<label>Electricity usage (kWh/100km):
    <input type="number" id="kwh" value="20" step="0.1">
  </label><br><br>

  <label>Electricity price (price/kWh):
    <input type="number" id="electricPrice" value="14" step="0.01">
  </label><br><br>

  <label>Fuel usage (L/100km):
    <input type="number" id="liters" value="7" step="0.1">
  </label><br><br>

  <label>Fuel price (price/L):
    <input type="number" id="fuelPrice" value="7" step="0.1">
  </label><br><br>

  <button onclick="calculate()">Compare Costs</button>

  <div class="result" id="result"></div>

  <h2>Diagonal Comparison Table</h2>
  <p>Updates based on electricity and fuel prices you enter.</p>
  <table id="comparisonTable">
    <thead>
      <tr>
        <th>Fuel L/100km ↓<br>Electric kWh/100km →</th>
        <th>10</th>
        <th>15</th>
        <th>20</th>
        <th>25</th>
        <th>30</th>
        <th>35</th>
        <th>40</th>
      </tr>
    </thead>
    <tbody id="tableBody">
      <!-- Dynamic content -->
    </tbody>
  </table>

  <script>
    function getClass(electricCost, fuelCost) {
      if (Math.abs(electricCost - fuelCost) < 0.01) return "equal";
      return electricCost < fuelCost ? "electric" : "gas";
    }

    function generateTable(electricPrice, fuelPrice) {
      const tableBody = document.getElementById("tableBody");
      tableBody.innerHTML = ""; // Clear previous

      const fuelUsages = [5, 6, 7, 8, 9, 10, 11,12];
      const electricUsages = [10, 15, 20, 25, 30, 35, 40];

      fuelUsages.forEach(fuelL => {
        const row = document.createElement("tr");
        const th = document.createElement("th");
        th.textContent = fuelL;
        row.appendChild(th);

        electricUsages.forEach(electricKWh => {
          const electricCost = electricKWh * electricPrice;
          const fuelCost = fuelL * fuelPrice;

          const cell = document.createElement("td");
          const cls = getClass(electricCost, fuelCost);
          cell.className = cls;
          cell.textContent = electricCost < fuelCost ? "🔌" : electricCost > fuelCost ? "⛽" : "⚖️";
          row.appendChild(cell);
        });

        tableBody.appendChild(row);
      });
    }

    function calculate() {
      const kwh = parseFloat(document.getElementById("kwh").value);
      const electricPrice = parseFloat(document.getElementById("electricPrice").value);
      const liters = parseFloat(document.getElementById("liters").value);
      const fuelPrice = parseFloat(document.getElementById("fuelPrice").value);

      const electricCost = kwh * electricPrice;
      const fuelCost = liters * fuelPrice;

      let cheaper = '';
      if (electricCost < fuelCost) {
        cheaper = "🔌 Electric is cheaper";
      } else if (electricCost > fuelCost) {
        cheaper = "⛽ Gas is cheaper";
      } else {
        cheaper = "⚖️ Both cost the same";
      }

      document.getElementById("result").innerHTML = `
        <p>Electric cost per 100 km: <strong>${electricCost.toFixed(2)} RON</strong></p>
        <p>Gas cost per 100 km: <strong>${fuelCost.toFixed(2)} RON</strong></p>
        <p>${cheaper}</p>
      `;

      generateTable(electricPrice, fuelPrice);
    }

    // Generate initial table
    window.onload = () => {
      const electricPrice = parseFloat(document.getElementById("electricPrice").value);
      const fuelPrice = parseFloat(document.getElementById("fuelPrice").value);
      generateTable(electricPrice, fuelPrice);
    };
  </script>