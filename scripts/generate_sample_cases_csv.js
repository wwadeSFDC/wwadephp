const fs = require('fs');
const rows = require('../occupied_apts.tmp.json');
// row: [apartmentId, apartmentName, accountId, accountName, propertyId, propertyName]

const byProperty = {};
for (const r of rows) {
  const propName = r[5];
  if (!byProperty[propName]) byProperty[propName] = [];
  byProperty[propName].push(r);
}

const scenarios = [
  { subject: 'Dripping kitchen faucet', description: 'Tenant reports the kitchen faucet has been dripping steadily for two days.', priority: 'Low', type: 'Problem', origin: 'Web', status: 'New' },
  { subject: 'HVAC not cooling', description: 'Unit HVAC is running but not cooling the apartment below 78F despite thermostat set to 70F.', priority: 'Medium', type: 'Problem', origin: 'Phone', status: 'New' },
  { subject: 'Refrigerator not cooling properly', description: 'Tenant reports refrigerator compartment is running warm; food has started to spoil.', priority: 'High', type: 'Problem', origin: 'Phone', status: 'Escalated' },
  { subject: 'Stuck kitchen drawer', description: 'Bottom kitchen drawer has come off its track and will not slide.', priority: 'Low', type: 'Problem', origin: 'Web', status: 'Closed' },
  { subject: 'Keyfob not working at building entrance', description: 'Tenant\'s keyfob no longer grants access at the main lobby door; works fine at the parking garage.', priority: 'Medium', type: 'Problem', origin: 'Web', status: 'New' },
  { subject: 'Noise complaint - upstairs unit', description: 'Tenant reports repeated late-night noise from the unit directly above, occurring most nights this week.', priority: 'Medium', type: 'Question', origin: 'Email', status: 'On Hold' },
  { subject: 'Water leak under bathroom sink', description: 'Active water leak under the bathroom sink cabinet; tenant has placed a bucket but water is pooling on the floor.', priority: 'High', type: 'Problem', origin: 'Phone', status: 'Escalated' },
  { subject: 'Dishwasher not draining', description: 'Dishwasher completes a cycle but standing water remains in the bottom of the unit afterward.', priority: 'Medium', type: 'Problem', origin: 'Web', status: 'New' },
  { subject: 'Smoke detector chirping', description: 'Smoke detector in the hallway has been chirping intermittently for several days, likely a low battery.', priority: 'Low', type: 'Problem', origin: 'Web', status: 'Closed' },
  { subject: 'Garbage disposal jammed', description: 'Garbage disposal hums but does not spin; tenant has not attempted to clear it themselves.', priority: 'Low', type: 'Problem', origin: 'Phone', status: 'New' },
  { subject: 'No heat in unit', description: 'Tenant reports no heat output overnight with outdoor temperatures near freezing.', priority: 'High', type: 'Problem', origin: 'Phone', status: 'Escalated' },
  { subject: 'Toilet running continuously', description: 'Toilet in the primary bathroom continues to run after each flush and is not resetting.', priority: 'Medium', type: 'Problem', origin: 'Web', status: 'On Hold' },
  { subject: 'Broken window latch', description: 'Bedroom window latch is broken and the window will not lock securely.', priority: 'Medium', type: 'Problem', origin: 'Web', status: 'New' },
  { subject: 'Ants observed in kitchen', description: 'Tenant has noticed a small ant trail near the kitchen baseboard over the past few days.', priority: 'Low', type: 'Problem', origin: 'Email', status: 'New' },
  { subject: 'Mailbox lock stuck', description: 'Tenant\'s assigned mailbox lock is stuck and the key will not turn.', priority: 'Low', type: 'Problem', origin: 'Web', status: 'Closed' },
  { subject: 'Ceiling light fixture flickering', description: 'Living room ceiling light flickers intermittently regardless of the bulb used.', priority: 'Low', type: 'Problem', origin: 'Web', status: 'New' },
  { subject: 'Parking spot access question', description: 'Tenant is asking whether their assigned parking spot includes an EV charging outlet.', priority: 'Low', type: 'Question', origin: 'Email', status: 'On Hold' },
  { subject: 'Gas smell reported near stove', description: 'Tenant reports a faint gas odor near the stove when the oven is in use.', priority: 'High', type: 'Problem', origin: 'Phone', status: 'Escalated' },
];

function csvEscape(val) {
  if (val == null) return '';
  const s = String(val);
  if (/[",\n]/.test(s)) return '"' + s.replace(/"/g, '""') + '"';
  return s;
}

const properties = Object.keys(byProperty);
const outRows = [];
let scenarioIdx = 0;
const perProperty = 3;

for (const propName of properties) {
  const candidates = byProperty[propName];
  // pick a spread across the property's occupied units, not just the first N
  const step = Math.max(1, Math.floor(candidates.length / perProperty));
  for (let i = 0; i < perProperty; i++) {
    const apt = candidates[(i * step) % candidates.length];
    const scenario = scenarios[scenarioIdx % scenarios.length];
    scenarioIdx++;
    outRows.push({
      AccountId: apt[2],
      Property__c: apt[4],
      Subject: scenario.subject,
      Description: scenario.description,
      Status: scenario.status,
      Priority: scenario.priority,
      Type: scenario.type,
      Origin: scenario.origin,
    });
  }
}

const header = ['AccountId', 'Property__c', 'Subject', 'Description', 'Status', 'Priority', 'Type', 'Origin'];
const lines = [header.join(',')];
for (const r of outRows) {
  lines.push(header.map(h => csvEscape(r[h])).join(','));
}

fs.writeFileSync('data/sample-cases.csv', lines.join('\n') + '\n');
console.log('Wrote', outRows.length, 'rows to data/sample-cases.csv');
console.log('Status distribution:', outRows.reduce((acc, r) => { acc[r.Status] = (acc[r.Status]||0)+1; return acc; }, {}));
