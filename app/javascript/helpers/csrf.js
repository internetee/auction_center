// Reads the Rails CSRF token from the page <meta> tag. Shared by the
// recommendation event controllers so the lookup lives in one place.
export function csrfToken() {
  return document.querySelector('meta[name="csrf-token"]')?.getAttribute("content")
}
