import React from 'react';

export interface CalendarEvent {
  id: string;
  title: string;
  /** ISO string or Date. */
  start: string | Date;
  /** Defaults to one hour after `start` in the time views. */
  end?: string | Date;
  /** Shows a dot instead of a time and pins to the top of a month cell. */
  allDay?: boolean;
  /** Semantic colour. @default brand blue */
  tone?: 'success' | 'warning' | 'danger' | 'neutral';
  /** Second line in agenda and long time-grid blocks. */
  meta?: string;
  /** Struck through — completed work. */
  done?: boolean;
}

/**
 * Calendar — month, week, day and agenda views over one event list.
 * For scheduling work: inspections, audits, line bookings, shipment windows.
 */
export interface CalendarProps extends React.HTMLAttributes<HTMLDivElement> {
  events: CalendarEvent[];
  /** @default "month" */
  view?: 'month' | 'week' | 'day' | 'agenda';
  /** Views offered in the toolbar. Pass one to hide the switch. */
  views?: Array<'month' | 'week' | 'day' | 'agenda'>;
  /** Date the calendar opens on. @default today */
  date?: string | Date;
  /** Reference "today" for the marker and the Today button. */
  today?: Date;
  onDateChange?: (date: Date) => void;
  onViewChange?: (view: string) => void;
  onEventClick?: (event: CalendarEvent) => void;
  /** Fired with the day and its events when a month cell is clicked. */
  onDayClick?: (date: Date, events: CalendarEvent[]) => void;
  /** Fired with the hour clicked in a week/day column — use to create. */
  onSelectSlot?: (date: Date) => void;
  /** Turns on dragging and the resize handle. Only when rescheduling is real. @default false */
  editable?: boolean;
  /** Dropped an event on a new day or hour. Persist, then feed `events` back. */
  onEventDrop?: (event: CalendarEvent, start: Date, end: Date | null) => void;
  /** Dragged an event's bottom edge in a time view. */
  onEventResize?: (event: CalendarEvent, start: Date, end: Date) => void;
  /** Adds an Edit button to the detail card. */
  onEventEdit?: (event: CalendarEvent) => void;
  /** Adds a Delete button to the detail card. */
  onEventDelete?: (event: CalendarEvent) => void;
  /** Open the detail card on click. Set false to handle `onEventClick` yourself. @default true */
  showDetail?: boolean;
  /** Drop and resize granularity in minutes. @default 15 */
  snapMinutes?: number;
  /** First hour shown in the time views. @default 6 */
  dayStart?: number;
  /** Last hour shown in the time views. @default 20 */
  dayEnd?: number;
  /** Events per month cell before "+n more". @default 3 */
  maxPerDay?: number;
  /** @default 640 */
  height?: number | string;
  /** Set false for a five-column working week. @default true */
  showWeekends?: boolean;
  /** Extra toolbar nodes, before the view switch. */
  actions?: React.ReactNode;
}

export function Calendar(props: CalendarProps): JSX.Element;
