import { LayoutDashboard, Map, Sliders, Bell, User, Home } from "lucide-react";
import { useLocation } from "wouter";
import { useEffect, useState } from "react";

export default function BottomNav() {
  const [location, setLocation] = useLocation();
  const [userRole, setUserRole] = useState<string | null>(null);

  useEffect(() => {
    // Ambil role dari sessionStorage atau context
    const role = sessionStorage.getItem("userRole") || "officer";
    setUserRole(role);
  }, []);

  const publicNavItems = [
    { path: "/home", icon: Home, label: "Home" },
    { path: "/control", icon: Sliders, label: "Control" },
    { path: "/monitor", icon: Map, label: "Monitor" },
    { path: "/profile", icon: User, label: "Profile" },
  ];

  const officerNavItems = [
    { path: "/dashboard", icon: LayoutDashboard, label: "Dashboard" },
    { path: "/monitoring", icon: Map, label: "Monitor" },
    { path: "/control", icon: Sliders, label: "Control" },
    { path: "/notifications", icon: Bell, label: "Alerts" },
    { path: "/profile", icon: User, label: "Profile" },
  ];

  const navItems = userRole === "public" ? publicNavItems : officerNavItems;

  return (
    <div className="fixed bottom-0 left-0 right-0 z-50 glassmorphism border-t">
      <nav className="flex items-center justify-around h-20 max-w-lg mx-auto px-4">
        {navItems.map((item) => {
          const Icon = item.icon;
          const isActive = location === item.path;
          return (
            <button
              key={item.path}
              onClick={() => setLocation(item.path)}
              className={`flex flex-col items-center gap-1 px-3 py-2 rounded-xl transition-all ${
                isActive ? "text-primary" : "text-muted-foreground"
              }`}
              data-testid={`nav-${item.label.toLowerCase()}`}
            >
              <div className={`relative ${isActive ? "scale-110" : ""} transition-transform`}>
                <Icon className="w-6 h-6" />
                {isActive && <div className="absolute -bottom-1 left-0 right-0 h-1 bg-primary rounded-full"></div>}
              </div>
              <span className="text-xs font-medium">{item.label}</span>
            </button>
          );
        })}
      </nav>
    </div>
  );
}
