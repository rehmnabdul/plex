/**
 * Interloop logo lockup — interlocking-loop insignia + "interloop" wordmark.
 *
 * @startingPoint section="Brand" subtitle="Logo lockup with tone & variant options" viewport="700x220"
 */
export interface LogoProps extends React.HTMLAttributes<HTMLSpanElement> {
  /** Which parts to render. @default "full" */
  variant?: 'full' | 'mark' | 'wordmark';
  /** Color treatment for the surface it sits on. @default "color" */
  tone?: 'color' | 'inverse' | 'mono';
  /** Mark height in px (wordmark scales from it). @default 28 */
  size?: number;
}

export function Logo(props: LogoProps): JSX.Element;
