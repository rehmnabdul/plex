import { zodResolver } from '@hookform/resolvers/zod';
import { useForm, Controller } from 'react-hook-form';
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Field } from '@/components/ui/label';
import { SwitchField } from '@/components/ui/switch';
import { Alert, AlertDescription, AlertTitle } from '@/components/ui/alert';
import {
  Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from '@/components/ui/select';
import { newOrderSchema, divisions, plants, type NewOrderInput } from '@/lib/api/types';
import { orderKeys, ordersApi } from '@/lib/api/orders';

/**
 * The house form pattern: Zod schema → `z.infer` type → `zodResolver`.
 * Runtime validation and the TS type stay in one place.
 */
export function NewOrderForm({ onDone }: { onDone?: () => void }) {
  const queryClient = useQueryClient();
  const {
    register, handleSubmit, control, reset,
    formState: { errors, isSubmitSuccessful },
  } = useForm<NewOrderInput>({
    resolver: zodResolver(newOrderSchema),
    defaultValues: { client: '', units: 1000, ship: '2026-11-30', rush: false, notes: '' },
  });

  const mutation = useMutation({
    mutationFn: ordersApi.create,
    onSuccess: () => {
      void queryClient.invalidateQueries({ queryKey: orderKeys.all });
      reset();
      onDone?.();
    },
  });

  return (
    <form onSubmit={handleSubmit((values) => mutation.mutate(values))} className="grid gap-4 sm:grid-cols-2" noValidate>
      <Field label="Client" required error={errors.client?.message} htmlFor="client" className="sm:col-span-2">
        <Input id="client" placeholder="Nordstrom Inc." invalid={!!errors.client} {...register('client')} />
      </Field>

      <Controller
        control={control}
        name="division"
        render={({ field }) => (
          <Field label="Division" required error={errors.division?.message}>
            <Select value={field.value} onValueChange={field.onChange}>
              <SelectTrigger aria-label="Division"><SelectValue placeholder="Choose…" /></SelectTrigger>
              <SelectContent>
                {divisions.map((d) => <SelectItem key={d} value={d}>{d}</SelectItem>)}
              </SelectContent>
            </Select>
          </Field>
        )}
      />

      <Controller
        control={control}
        name="plant"
        render={({ field }) => (
          <Field label="Plant" required error={errors.plant?.message}>
            <Select value={field.value} onValueChange={field.onChange}>
              <SelectTrigger aria-label="Plant"><SelectValue placeholder="Choose…" /></SelectTrigger>
              <SelectContent>
                {plants.map((p) => <SelectItem key={p} value={p}>{p}</SelectItem>)}
              </SelectContent>
            </Select>
          </Field>
        )}
      />

      <Field label="Units" required error={errors.units?.message} htmlFor="units">
        <Input id="units" type="number" inputMode="numeric" invalid={!!errors.units} {...register('units')} />
      </Field>

      <Field label="Ship date" required error={errors.ship?.message} htmlFor="ship">
        <Input id="ship" type="date" invalid={!!errors.ship} {...register('ship')} />
      </Field>

      <Field label="Notes" hint="Optional — max 280 characters" error={errors.notes?.message} htmlFor="notes" className="sm:col-span-2">
        <Input id="notes" placeholder="Anything planning should know" invalid={!!errors.notes} {...register('notes')} />
      </Field>

      <Controller
        control={control}
        name="rush"
        render={({ field }) => (
          <SwitchField
            className="sm:col-span-2"
            label="Rush order"
            description="Skips the planning queue and starts production immediately"
            checked={field.value}
            onCheckedChange={field.onChange}
          />
        )}
      />

      {mutation.isError && (
        <Alert variant="destructive" className="sm:col-span-2">
          <AlertTitle>Could not create the order</AlertTitle>
          <AlertDescription>{(mutation.error as Error).message}</AlertDescription>
        </Alert>
      )}
      {isSubmitSuccessful && mutation.isSuccess && (
        <Alert variant="success" className="sm:col-span-2">
          <AlertTitle>Order created</AlertTitle>
          <AlertDescription>{mutation.data.id} was added to the planning queue.</AlertDescription>
        </Alert>
      )}

      <div className="flex gap-2 sm:col-span-2">
        <Button type="submit" loading={mutation.isPending}>Create order</Button>
        <Button type="button" variant="ghost" onClick={() => reset()}>Reset</Button>
      </div>
    </form>
  );
}
