export default async function Layout({
                                       children,
                                     }: {
  children: React.ReactNode;
}) {
  return (
      <div className="h-full flex items-center justify-center">
        <div className="max-w-7xl flex flex-col gap-12 items-center justify-center">
          {children}
        </div>
      </div>
  );
}