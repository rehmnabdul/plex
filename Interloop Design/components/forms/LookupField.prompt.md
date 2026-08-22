# LookupField · RangeSlider · SplitButton

See `Combobox.prompt.md` for the shared field grammar and the picker decision table. This file covers the API.

## LookupField

For picking one record out of thousands, where a dropdown would be useless.

```jsx
<LookupField
  label="Order" value={order} onChange={setOrder}
  displayKey="id" metaKey="client" title="Select an order"
  columns={[{ key: 'id', header: 'Order' }, { key: 'client', header: 'Client' },
            { key: 'units', header: 'Units', numeric: true }]}
  rows={orders}
/>
```

Click selects, double-click or Enter confirms, **Select** commits — nothing reaches the form until the user confirms, so cancelling really cancels. Below ~50 records the modal costs more than it saves; use a `Combobox`.

## RangeSlider

```jsx
<RangeSlider label="Lot size" value={[2000, 40000]} onChange={setRange} min={0} max={90000} step={500} unit=" pcs" />
```

Two thumbs on one track that cannot cross. Always show the readout — a slider without numbers is a guess. Use it for bounded filters, never for a value that needs to be exact.

## SplitButton

```jsx
<SplitButton label="Save" onClick={save} items={[
  { label: 'Save and new', onSelect: saveNew },
  { label: 'Save and close', onSelect: saveClose },
  { separator: true },
  { label: 'Discard changes', onSelect: discard, danger: true },
]} />
```

The main button must be what people want 80% of the time. If you can't name that one action, use separate buttons instead.
